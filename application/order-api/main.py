import logging
import os
from datetime import datetime, timezone
from uuid import uuid4

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("order-api")

app = FastAPI(
    title="Enterprise Order Processing API",
    version="1.0.0",
)

# Temporary lab storage; not durable or multi-replica safe.
orders = {}


class OrderRequest(BaseModel):
    product_id: str = Field(min_length=1, max_length=100)
    quantity: int = Field(gt=0, le=100)


@app.get("/")
def root():
    return {
        "service": "order-api",
        "version": "1.0.0",
        "environment": os.getenv("APP_ENV", "dev"),
    }


@app.get("/health/live")
def liveness():
    return {"status": "alive"}


@app.get("/health/ready")
def readiness():
    return {"status": "ready"}


@app.post("/orders", status_code=201)
def create_order(payload: OrderRequest):
    order_id = str(uuid4())

    order = {
        "order_id": order_id,
        "product_id": payload.product_id,
        "quantity": payload.quantity,
        "status": "CREATED",
        "created_at": datetime.now(timezone.utc).isoformat(),
    }

    orders[order_id] = order

    logger.info("order_created order_id=%s", order_id)

    return order


@app.get("/orders/{order_id}")
def get_order(order_id: str):
    result = orders.get(order_id)

    if result is None:
        raise HTTPException(status_code=404, detail="Order not found")

    return result
