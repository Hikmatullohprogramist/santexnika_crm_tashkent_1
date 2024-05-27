double calculateSumma(double price, double dollar, int moneyFormId, int selectedValueMoneyForm) {
  double result;
  if (moneyFormId == 2 && selectedValueMoneyForm != 2) {
    result = price * dollar;
  } else if (moneyFormId == 1 && selectedValueMoneyForm != 1) {
    result = price / dollar;
  } else {
    result = price;
  }
  return double.parse(result.toStringAsFixed(2));
}
