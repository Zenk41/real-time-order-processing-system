package domain

import (
	"time"

	"github.com/google/uuid"
)

// ProductClearance represents the product_clearance table
type ProductClearance struct {
	ProductClearanceID uuid.UUID  `json:"product_clearance_id" db:"product_clearance_id"`
	ProductID          uuid.UUID  `json:"product_id" db:"product_id"`
	DiscountPercentage string     `json:"discount_percentage" db:"discount_percentage"`
	StartDate          *time.Time `json:"start_date,omitempty" db:"start_date"`
	EndDate            *time.Time `json:"end_date,omitempty" db:"end_date"`
}
