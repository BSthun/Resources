package model

type ClientState struct {
	Id       *int64  `gorm:"primaryKey"`
	ClientId *int64  `gorm:"not null"`
	Client   *Client `gorm:"foreignKey:ClientId; constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	State    *string `gorm:"type:varchar(255); index:state,unique; not null"`
}
