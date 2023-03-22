package functions

import (
	"net/http"
	"net/url"
	"strings"

	"github.com/gofiber/fiber/v2"

	"backend/modules/config"
	"backend/modules/db/model"
	"backend/types/payload"
	"backend/types/response"
)

func SpotifyRedirectUri() string {
	return config.C.BaseUrl + "/api/login/callback"
}

func SpotifyGetRefreshToken(c *fiber.Ctx, client *model.Client, grantType string, code string) (*payload.LoginSpotifyCredentials, *response.ErrorInstance) {
	values := url.Values{}
	values.Set("grant_type", grantType)
	values.Set("code", code)
	values.Set("redirect_uri", SpotifyRedirectUri())

	var data *payload.LoginSpotifyCredentials
	if err := DoRequest(
		c,
		"POST",
		"https://accounts.spotify.com/api/token",
		strings.NewReader(values.Encode()),
		func(r *http.Request) {
			r.Header.Set("Content-Type", "application/x-www-form-urlencoded")
			r.Header.Set("Authorization", "Basic "+*client.Authorization)
		},
		&data,
	); err != nil {
		return nil, err
	}

	return data, nil
}
