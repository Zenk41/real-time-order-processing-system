package domain

import (
	"github.com/google/uuid"
)

// CartProduct represents the cart_product table (many-to-many relationship)
type CartProduct struct {
	CartID    uuid.UUID `json:"cart_id" db:"cart_id"`
	ProductID uuid.UUID `json:"product_id" db:"product_id"`
}
