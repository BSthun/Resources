package model

type Client struct {
	Id                  *int64  `gorm:"primaryKey"`
	SpotifyClientId     *string `gorm:"type:varchar(255); index:spotify_client_id,unique; not null" yaml:"cid"`
	SpotifyClientSecret *string `gorm:"type:varchar(255); not null" yaml:"secret"`
	Authorization       *string `gorm:"type:varchar(255); not null"`
}

type ClientWithCount struct {
	*Client
	UsageCount int64 `gorm:"column:usage_count" yaml:"count"`
}
