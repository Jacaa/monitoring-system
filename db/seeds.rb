# Is human and walked in
5.times do |n|
  Event.create!(
    is_human: true,
    walked_in: true,
    photo: "photo-#{n}",
    created_at: (20+n).minutes.ago,
    updated_at: (20+n).minutes.ago)
end

# Is human and walked out
5.times do |n|
  Event.create!(
    is_human: true,
    walked_in: false,
    photo: "no photo",
    created_at: (10+n).minutes.ago,
    updated_at: (10+n).minutes.ago)
end

# Is no human - car (can't walk in)
5.times do |n|
  Event.create!(
    is_human: false,
    walked_in: false,
    photo: "car-photo-#{n}",
    created_at: (1+n).hours.ago,
    updated_at: (1+n).hours.ago)
end
