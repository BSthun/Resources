package common

type UserClaims struct {
	UserId *uint64 `json:"user_id"`
}

func (v *UserClaims) Valid() error {
	return nil
}
