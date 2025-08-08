# src/calculator.py


class Calculator:
    """Une simple calculatrice."""

    def add(self, a, b):
        """Additionne deux nombres."""
        return a + b

    def divide(self, a, b):
        """Divise a par b. Lève ZeroDivisionError si b vaut 0."""
        if b == 0:
            raise ZeroDivisionError("Division par zéro non autorisée")
        return a / b
