package domain

import (
	"github.com/google/uuid"
)

// CollectionProduct represents the collection_product table (many-to-many relationship)
type CollectionProduct struct {
	CollectionProductID uuid.UUID `json:"collection_product_id" db:"collection_product_id"`
	CollectionID        uuid.UUID `json:"collection_id" db:"collection_id"`
	ProductID           uuid.UUID `json:"product_id" db:"product_id"`
}
