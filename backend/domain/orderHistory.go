package domain

import (
	"time"

	"github.com/google/uuid"
)

// OrderHistory represents the order_history table
type OrderHistory struct {
	OrderHistoryID uuid.UUID           `json:"order_history_id" db:"order_history_id"`
	AccountID      uuid.UUID           `json:"account_id" db:"account_id"`
	Address        map[string]string   `json:"address,omitempty" db:"address"`
	Products       []map[string]string `json:"products,omitempty" db:"products"`
	PaymentStatus  string              `json:"payment_status" db:"payment_status"`
	OrderTimestamp time.Time           `json:"order_timestamp" db:"order_timestamp"`
	ShipmentStatus string              `json:"shipment_status" db:"shipment_status"`
	OrderStatus    string              `json:"order_status" db:"order_status"`
}
