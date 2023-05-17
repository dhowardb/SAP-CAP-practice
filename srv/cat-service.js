module.exports = (srv) => {
	//Use reflection to get the csn definition of Books
	const { Books } = cds.entities;

	//Add some discount for overstocked books
	srv.after('READ', 'Books', (each) => {
		if (each.stock > 111) each.title += ' -- 11% discount!';
	});

	//Reduce stock of books upon incoming orders
	srv.before('CREATE', 'Orders', async (req) => {
		const { Items: orderItems } = req.data;

		return cds
			.transaction(req)
			.run(() =>
				orderItems.map((item) =>
					UPDATE(Books)
						.set('stock -=', item.amount)
						.where('ID =', item.book_ID)
						.and('stock >', item.amount)
				)
			)
			.then((all) =>
				all.forEach(affectedRows, (i) => {
					if (affectedRows === 0) {
						req.error(
							409,
							`${orderItems[i].amount} exceeds stock for book #${orderItems[i].book_ID}`
						);
					}
				})
			);
	});
};
