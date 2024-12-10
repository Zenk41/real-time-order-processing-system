package domain

import (
	"time"

	"github.com/google/uuid"
)


// Order represents the orders table
type Order struct {
	OrderID           uuid.UUID `json:"order_id" db:"order_id"`
	AccountID         uuid.UUID `json:"account_id" db:"account_id"`
	AccountAddressID  uuid.UUID `json:"account_address_id" db:"account_address_id"`
	PaymentStatus     string    `json:"payment_status" db:"payment_status"`
	OrderTimestamp    time.Time `json:"order_timestamp" db:"order_timestamp"`
	ShipmentStatus    string    `json:"shipment_status" db:"shipment_status"`
	OrderStatus       string    `json:"order_status" db:"order_status"`
	CreatedAt         time.Time `json:"created_at" db:"created_at"`
	UpdatedAt         time.Time `json:"updated_at" db:"updated_at"`
}