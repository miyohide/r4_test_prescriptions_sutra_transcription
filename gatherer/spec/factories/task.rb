FactoryGirl.define do
  factory :task do
    # sequenceは連番を生成する
    sequence(:title) { |n| "Task #{n}"}

    # traitは1つの属性だけの意味付けって感じ。
    # これだけでFactoryGirl.build(:small)ってやっても
    # Factory not registeredが出て落ちてしまう
    trait :small do
      size 1
    end

    trait :large do
      size 5
    end

    trait :soon do
      due_date { 1.day.from_now }
    end

    trait :later do
      due_date { 1.month.from_now }
    end

    # traitの使い方。traitを並べてFactoryとして定義するって形
    factory :trivial do
      small
      later
    end

    factory :panic do
      large
      soon
    end
  end
end
