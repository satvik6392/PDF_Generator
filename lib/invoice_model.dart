class Invoice {
  late String address;
  late String supplierName;
  late String customerName;
  late List<InvoiceItem> items;

  Invoice({
    required this.address,
    required this.supplierName,
    required this.customerName,
    required this.items,
  });

  Invoice.fromJson(Map<dynamic, dynamic> json) {
    address = json['address'];
    supplierName = json['supplierName'];
    customerName = json['customerName'];
    items = List<InvoiceItem>.from(
        json['items'].map((item) => InvoiceItem.fromJson(item)));
  }
}

class InvoiceItem {
  late String id;
  late String seat;
  late String no;
  late String date;
  late String method;
  late String amount;

  InvoiceItem({
    required this.no,
    required this.amount,
    required this.date,
    required this.id,
    required this.method,
    required this.seat,
  });

  InvoiceItem.fromJson(Map<dynamic, dynamic> json) {
    no = json['no'];
    id = json['id'];
    amount = json['amount'];
    seat = json['seat'];
    date = json['date'];
    method = json['method'];
  }
}
