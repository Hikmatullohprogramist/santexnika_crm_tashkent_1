String checkTradeType(int tradeType) {
  switch (tradeType) {
    case 1:
      return "Naqd";
    case 2:
      return "Plastik";
    case 3:
      return "Click";
    case 4:
      return "Nasiya";
    case 5:
      return "Narxdan tushilgan";
    default:
      return "";
  }
}
