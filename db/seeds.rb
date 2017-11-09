Event.destroy_all

10.times do |n|
  Event.create!(
    walked_in: true,
    photo: 'link',
    created_at: (48+n).hours.ago
  )
end

10.times do |n|
  Event.create!(
    walked_in: false,
    photo: 'no photo',
    created_at: (24+n).hours.ago
  )
end

a = true
15.times do |n|
  a = !a
  Event.create!(
    walked_in: a,
    photo: 'link',
    created_at: (n+1).hours.ago
  )
end

a = false
10.times do |n|
  a = !a
  Event.create!(
    walked_in: a,
    photo: "link",
    created_at: (20+n).minutes.ago
  )
end

3.times do |n|
  Event.create!(
    walked_in: true,
    photo: "no photo",
    created_at: (10+n).minutes.ago
    )
end
