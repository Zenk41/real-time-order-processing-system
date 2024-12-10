package domain

import (
	"time"

	"github.com/google/uuid"
)

// AccountAddress represents the account_address table (many-to-many relationship)
type AccountAddress struct {
	AccountAddressID uuid.UUID `json:"account_address_id" db:"account_address_id"`
	AccountID        uuid.UUID `json:"account_id" db:"account_id"`
	AddressID        uuid.UUID `json:"address_id" db:"address_id"`
	CreatedAt        time.Time `json:"created_at" db:"created_at"`
	UpdatedAt        time.Time `json:"updated_at" db:"updated_at"`
}
