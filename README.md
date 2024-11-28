# Real-Time Order Processing System

This project demonstrates how to build a real-time order processing system using **Apache Kafka**. The system simulates an order lifecycle in an e-commerce platform, processing orders in real-time from placement to shipment. 

The system uses Kafka for event streaming to decouple services like order placement, payment verification, inventory update, and shipment preparation.

## Features

- **Order Placement**: User places an order, which triggers an event to Kafka.
- **Payment Verification**: A service verifies payment and updates the order status.
- **Inventory Update**: Once payment is verified, the inventory is updated in real-time.
- **Shipment Preparation**: After inventory update, the shipment process is triggered.
- **Order Status Tracking**: Track the current status of the order in a database.
- **Real-Time Notifications**: Send real-time notifications to the customer when the order is shipped.
- **Optional Analytics**: Aggregate real-time order data for simple analytics (e.g., number of orders placed, items sold).

## Architecture

The system is composed of several key components:

1. **Producer**:
   - A service that produces order events when an order is placed.
2. **Consumers**:
   - **Payment Verification Service**: Verifies the payment status and updates the order.
   - **Inventory Update Service**: Updates the inventory and tracks stock levels.
   - **Shipment Service**: Prepares the order for shipment.
3. **Kafka**:
   - Used as the messaging platform for decoupling the different services. Kafka topics like `order-placed`, `payment-verified`, `inventory-updated`, and `order-shipped` are used.
4. **Database**:
   - Stores order status and other relevant data for tracking and analytics.
5. **Real-Time Notification Service**:
   - Sends email or push notifications when the order status changes.

## Tech Stack

- **Backend**:
  - Kafka (Producer and Consumer)
  - Node.js / Go / Java for services
- **Frontend**:
  - React or HTML/CSS for the order placement interface
- **Database**:
  - PostgreSQL / MongoDB for storing order status
- **Notifications**:
  - SendGrid or Firebase Cloud Messaging for real-time notifications
- **Kafka Setup**:
  - Apache Kafka for message queuing and event processing

## Getting Started

### Prerequisites

Before running the project, ensure you have the following installed:

- Docker (for running Kafka and Zookeeper)
- Node.js / Go / Java (for backend services)
- PostgreSQL / MongoDB (for data storage)
- Kafka Setup (Docker setup for Kafka, Zookeeper, and Kafka broker)

### Setup

1. **Clone the repository**:

   ```bash
   git clone https://github.com/yourusername/real-time-order-processing-system.git
   cd real-time-order-processing-system
