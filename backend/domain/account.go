package domain

import (
	"time"

	"github.com/google/uuid"
)

// Account represents the accounts table
type Account struct {
	AccountID     uuid.UUID `json:"account_id" db:"account_id"`
	AccountName   string    `json:"account_name" db:"account_name"`
	AccountEmail  string    `json:"account_email" db:"account_email"`
	AccountPassword string  `json:"-" db:"account_password"`
	OTPEnabled    bool      `json:"otp_enabled" db:"otp_enabled"`
	OTPVerified   bool      `json:"otp_verified" db:"otp_verified"`
	OTPSecret     *string   `json:"otp_secret,omitempty" db:"otp_secret"`
	OTPAuthURL    *string   `json:"otp_auth_url,omitempty" db:"otp_auth_url"`
	CreatedAt     time.Time `json:"created_at" db:"created_at"`
	UpdatedAt     time.Time `json:"updated_at" db:"updated_at"`
}
