Event.destroy_all

a = false
13.times do |n|
  a = !a
  Event.create!(
    walked_in: a,
    photo: 'no photo',
    created_at: 14.days.ago
  )
end

9.times do |n|
  Event.create!(
    walked_in: true,
    photo: 'no photo',
    created_at: 13.days.ago
  )
end

7.times do |n|
  Event.create!(
    walked_in: false,
    photo: 'no photo',
    created_at: 12.days.ago
  )
end

3.times do |n|
  Event.create!(
    walked_in: false,
    photo: 'no photo',
    created_at: 8.days.ago
  )
end

a = true
11.times do |n|
  a = !a
  Event.create!(
    walked_in: a,
    photo: 'no photo',
    created_at: 4.days.ago
  )
end

a = false
10.times do |n|
  a = !a
  Event.create!(
    walked_in: a,
    photo: 'no photo',
    created_at: (48+n).hours.ago
  )
end

a = true
15.times do |n|
  a = !a
  Event.create!(
    walked_in: a,
    photo: 'no photo',
    created_at: (24+n).hours.ago
  )
end

6.times do |n|
  Event.create!(
    walked_in: true,
    photo: "no photo",
    created_at: (10+n).minutes.ago
    )
end

Event.create!(
  walked_in: true,
  photo: "photo_27112017201657.jpeg",
  created_at: DateTime.strptime("27/11/2017 20:16:57", "%m/%d/%Y %H:%M:%S")
)
