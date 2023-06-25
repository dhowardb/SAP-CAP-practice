namespace sap.capire.bookshop;

using {
    Currency,
    managed,
    cuid
} from '@sap/cds/common';

using {sap.capire.products.Products} from '../../products';


aspect additionalInfo {
    genre    : String(100);
    language : String(200);
}

// entity Books : managed, additionalInfo {
//     key ID       : Integer;
//         title    : localized String(111);
//         descr    : localized String(1111);
//         author   : Association to Authors;
//         stock    : Integer;
//         price    : Decimal(9, 2);
//         currency : Currency;
// }

entity Books : additionalInfo, Products {
    author : Association to Authors;
}

entity Magazines : additionalInfo, Products {
    publisher : String;
}

entity Authors : managed {
    key ID    : Integer;
        name  : String(111);
        books : Association to many Books
                    on books.author = $self;
}

entity Orders : managed, cuid {
    // key ID      : UUID;
    OrderNo : String @title: 'Order Number'; //> readable key
    Items   : Composition of many OrderItems
                  on Items.parent = $self;
}

entity OrderItems : cuid {
    // key ID     : UUID;
    parent : Association to Orders;
    book   : Association to Books;
    amount : Integer;
}

entity Movies : additionalInfo {
    key ID   : Integer;
        name : String(111);
}
