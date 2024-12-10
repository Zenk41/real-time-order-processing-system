package domain

import (
	"time"

	"github.com/google/uuid"
)

// Product represents the product table
type Product struct {
	ProductID          uuid.UUID           `json:"product_id" db:"product_id"`
	ProductName        string              `json:"product_name" db:"product_name"`
	Images             map[string][]string `json:"images,omitempty" db:"images"`
	ProductDescription *string             `json:"product_description,omitempty" db:"product_description"`
	Quantity           int                 `json:"quantity" db:"quantity"`
	Clearance          bool                `json:"clearance" db:"clearance"`
	Featured           bool                `json:"featured" db:"featured"`
	CategoryID         *uuid.UUID          `json:"category_id,omitempty" db:"category_id"`
	CreatedAt          time.Time           `json:"created_at" db:"created_at"`
	UpdatedAt          time.Time           `json:"updated_at" db:"updated_at"`
}
