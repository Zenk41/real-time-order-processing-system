package domain

import (
	"github.com/google/uuid"
)

// OrderProduct represents the order_product table (many-to-many relationship)
type OrderProduct struct {
	OrderID   uuid.UUID `json:"order_id" db:"order_id"`
	ProductID uuid.UUID `json:"product_id" db:"product_id"`
}
