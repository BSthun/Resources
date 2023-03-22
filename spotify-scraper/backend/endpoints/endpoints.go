package endpoints

import (
	"github.com/gofiber/fiber/v2"

	loginEndpoint "backend/endpoints/login"
	"backend/modules/fiber/middlewares"
)

func Init(router fiber.Router) {
	// * Login
	login := router.Group("login/", middlewares.Sentry())
	login.Get("redirect", loginEndpoint.RedirectHandler)
	login.Get("callback", loginEndpoint.HandleCallback)
}
