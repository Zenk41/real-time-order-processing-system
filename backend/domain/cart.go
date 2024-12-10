package domain

import (
	"time"

	"github.com/google/uuid"
)

// Cart represents the cart table
type Cart struct {
	CartID    uuid.UUID `json:"cart_id" db:"cart_id"`
	AccountID uuid.UUID `json:"account_id" db:"account_id"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
	UpdatedAt time.Time `json:"updated_at" db:"updated_at"`
}
