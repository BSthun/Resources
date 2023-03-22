package login

import (
	"net/url"

	"github.com/gofiber/fiber/v2"

	"backend/functions"
	"backend/modules/db"
	"backend/modules/db/model"
	"backend/types/response"
	"backend/utils/text"
)

func RedirectHandler(c *fiber.Ctx) error {
	// * Query client usage count
	var clients []*model.ClientWithCount
	if result := db.DB.Model(new(model.Client)).Select("clients.*, COUNT(users.id) AS usage_count").Joins("LEFT JOIN users ON clients.id = users.client_id").Group("clients.id").Find(&clients); result.Error != nil {
		return response.Error(c, true, "Unable to query client usage count", result.Error)
	}

	// * Get available client
	var client *model.Client
	for _, cli := range clients {
		if cli.UsageCount < 25 {
			client = cli.Client
			break
		}
	}

	// * Handle no available client
	if client == nil {
		return response.Error(c, true, "No available client")
	}

	// * Create OAuth state
	oauthState := &model.ClientState{
		Id:       nil,
		ClientId: client.Id,
		Client:   nil,
		State:    text.Random(text.StringSet.MixedAlphaNum, 12),
	}
	if result := db.DB.Create(oauthState); result.Error != nil {
		return response.Error(c, true, "Unable to create OAuth state", result.Error)
	}

	values := url.Values{}
	values.Set("response_type", "code")
	values.Set("client_id", *client.SpotifyClientId)
	values.Set("scope", "user-read-playback-state")
	values.Set("redirect_uri", functions.SpotifyRedirectUri())
	values.Set("state", *oauthState.State)

	target := "https://accounts.spotify.com/authorize"
	target += "?" + values.Encode()

	return c.Redirect(target, fiber.StatusTemporaryRedirect)
}
