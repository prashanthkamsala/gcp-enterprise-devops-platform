from fastapi.testclient import TestClient

from main import app

client = TestClient(app)


def test_liveness():
    response = client.get("/health/live")

    assert response.status_code == 200
    assert response.json() == {"status": "alive"}


def test_readiness():
    response = client.get("/health/ready")

    assert response.status_code == 200
    assert response.json() == {"status": "ready"}


def test_create_and_fetch_order():
    payload = {
        "product_id": "TEST-LAPTOP-001",
        "quantity": 2,
    }

    create_response = client.post("/orders", json=payload)

    assert create_response.status_code == 201

    order = create_response.json()

    assert order["product_id"] == payload["product_id"]
    assert order["quantity"] == payload["quantity"]
    assert order["status"] == "CREATED"
    assert "order_id" in order

    get_response = client.get(f"/orders/{order['order_id']}")

    assert get_response.status_code == 200
    assert get_response.json() == order


def test_invalid_quantity():
    response = client.post(
        "/orders",
        json={
            "product_id": "TEST-LAPTOP-001",
            "quantity": 0,
        },
    )

    assert response.status_code == 422


def test_unknown_order():
    response = client.get("/orders/nonexistent-order-id")

    assert response.status_code == 404