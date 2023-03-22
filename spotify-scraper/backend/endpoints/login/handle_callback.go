package login

import (
	"github.com/gofiber/fiber/v2"

	"backend/functions"
	"backend/modules/db"
	"backend/modules/db/model"
	"backend/types/payload"
	"backend/types/response"
)

func HandleCallback(c *fiber.Ctx) error {
	// * Parse query
	query := new(payload.LoginSpotifyCallback)
	if err := c.QueryParser(query); err != nil {
		return response.Error(c, true, "Unable to parse query", err)
	}

	// * Check state
	var oauthState *model.ClientState
	if result := db.DB.Preload("Client").First(&oauthState, "state = ?", query.State); result.Error != nil {
		return response.Error(c, true, "Unable to find OAuth state", result.Error)
	}

	// * Check code
	credentials, err := functions.SpotifyGetRefreshToken(c, oauthState.Client, "authorization_code", query.Code)
	if err != nil {
		return err
	}

	// * Check user exists
	profile, err := functions.SpotifyGetProfile(c, *credentials.AccessToken)
	if err != nil {
		return err
	}

	var user *model.User
	if result := db.DB.First(&user, "spotify_id = ?", *profile.Id); result.Error != nil {
		// * Create user
		user = &model.User{
			Id:        nil,
			ClientId:  oauthState.Client.Id,
			Client:    nil,
			SpotifyId: profile.Id,
			Profile:   profile,
		}
		if result := db.DB.Create(user); result.Error != nil {
			return response.Error(c, true, "Unable to create user", result.Error)
		}
	}

	return c.JSON(response.Info(c, map[string]interface{}{
		"accessToken": *credentials.AccessToken,
	}))
}
