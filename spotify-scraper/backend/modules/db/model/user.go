package model

import "backend/types/payload"

type User struct {
	Id        *int64                  `gorm:"primaryKey"`
	ClientId  *int64                  `gorm:"not null"`
	Client    *Client                 `gorm:"foreignKey:ClientId; constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	SpotifyId *string                 `gorm:"uniqueIndex;not null"`
	Profile   *payload.SpotifyProfile `gorm:"type:json;not null"`
}
