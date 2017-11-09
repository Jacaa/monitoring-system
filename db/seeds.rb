# Is human and walked in
10.times do |n|
  Event.create!(
    walked_in: true,
    photo: "photo-#{n}",
    created_at: (20+n).minutes.ago,
    updated_at: (20+n).minutes.ago)
end

# Is human and walked out
10.times do |n|
  Event.create!(
    walked_in: false,
    photo: "no photo",
    created_at: (10+n).minutes.ago,
    updated_at: (10+n).minutes.ago)
end
