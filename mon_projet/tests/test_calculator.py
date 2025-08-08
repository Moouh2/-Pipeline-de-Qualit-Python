# tests/test_calculator.py
import pytest
from src.calculator import Calculator


class TestCalculator:
    """Tests pour la classe Calculator."""

    def setup_method(self):
        """Configuration avant chaque test."""
        self.calculator = Calculator()

    def test_add_positive_numbers(self):
        """Test addition de nombres positifs."""
        result = self.calculator.add(2, 3)
        assert result == 5

    def test_add_negative_numbers(self):
        """Test addition de nombres négatifs."""
        result = self.calculator.add(-2, -3)
        assert result == -5

    def test_divide_by_zero_raises_error(self):
        """Test division par zéro lève une exception."""
        with pytest.raises(ZeroDivisionError):
            self.calculator.divide(10, 0)
