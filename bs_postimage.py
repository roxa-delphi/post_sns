# Post image to Bluesky used atproto library
#
# atproto install :
#  % python3 -m venv atproto
#  % source atproto/bin/activate
#  % sudo pip3 install atproto
#
# execute :
#  atproto/bin/python3 bs_postimage.py "Post_message" Image_filename
#
import os
import sys
import time
from datetime import datetime
from atproto import Client, models

mess = sys.argv[1]
image_path = sys.argv[2]

# Login
client = Client()
client.login('account-name', 'password')


#print("messages : " + mess)
#print("path     : " + image_path)


# Upload images
with open(image_path, "rb") as f:
  img_data = f.read()

  upload = client.upload_blob(img_data)
  bs_images = [models.AppBskyEmbedImages.Image(alt='Image', image=upload.blob)]
  bs_embed  = models.AppBskyEmbedImages.Main(images=bs_images)


  # Post
  client.com.atproto.repo.create_record(
    models.ComAtprotoRepoCreateRecord.Data(
      repo=client.me.did,
      collection=models.ids.AppBskyFeedPost,
      record=models.AppBskyFeedPost.Record(
        created_at=client.get_current_time_iso(), text=mess, embed=bs_embed
      )
    )
  )


