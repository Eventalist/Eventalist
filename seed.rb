yoshie = User.create({name: 'yoshie'})
tess = User.create({name: 'tess'})
tim = User.create({name: 'tim'})
eric = User.create({name: 'eric'})

dance = Category.create({name: 'dance'})
jazz = Category.create({name: 'jazz'})
classical = Category.create({name: 'classical'})

Subscription.create({user_id: yoshie.id, category_id: dance.id})

Subscription.create({user_id: tess.id, category_id: jazz.id})

Subscription.create({user_id: tim.id, category_id: classical.id})

Subscription.create({user_id: eric.id, category_id: dance.id})