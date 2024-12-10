package domain

import (
	"time"

	"github.com/google/uuid"
)

// Address represents the address table
type Address struct {
	AddressID     uuid.UUID `json:"address_id" db:"address_id"`
	Recipient     string    `json:"recipient" db:"recipient"`
	StreetAddress string    `json:"street_address" db:"street_address"`
	AddressLine2  *string   `json:"address_line2,omitempty" db:"address_line2"`
	City          string    `json:"city" db:"city"`
	State         *string   `json:"state,omitempty" db:"state"`
	PostalCode    string    `json:"postal_code" db:"postal_code"`
	Country       string    `json:"country" db:"country"`
	IsDefault     bool      `json:"is_default" db:"is_default"`
	PhoneNumber   *string   `json:"phone_number,omitempty" db:"phone_number"`
	AddressType   *string   `json:"address_type,omitempty" db:"address_type"`
	CreatedAt     time.Time `json:"created_at" db:"created_at"`
	UpdatedAt     time.Time `json:"updated_at" db:"updated_at"`
}