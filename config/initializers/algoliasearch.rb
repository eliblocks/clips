AlgoliaSearch.configuration = { application_id: Rails.application.credentials.algolia_id,
                                api_key: Rails.application.credentials.algolia_secret,
                                pagination_backend: :kaminari }
