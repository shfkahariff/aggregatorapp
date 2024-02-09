json.extract! post, :id, :headlines, :titleurl, :created_at, :updated_at
json.url post_url(post, format: :json)
