Rails.application.config.middleware.use OmniAuth::Builder do
  
  if Rails.env.production?
    
  else
    provider :facebook, '159010444136603', '3d928ab555edf4a95c70e41ff3307256'
    provider :twitter, 'b5RW7u1jXcYZLvIpwXiGqw', 'nS10oy5gvd7yVdBt5NodpQrNM8BaEtyaGVtVLHdrVI'
    provider :gplus, '690397478446.apps.googleusercontent.com', 'FqkkinNgkHTk-H9M_paAzax4'
  end
end
