<<<<<<< HEAD
require "active_record"
require_relative "./lib/connection-tess"
=======
require 'pry'
require 'active_record'
require_relative "./lib/connection-tim"
>>>>>>> 7634d9ad2eeee5f43804d564949238904f39ef96
# require_relative "/lib/connection-yoshie"
# require_relative "/lib/connection-eric"
# require_relative "/lib/connection-tim"
require_relative "./lib/methods"

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