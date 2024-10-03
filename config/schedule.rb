
set :chronic_options, hours24: true, now: Chronic.parse("now in JST")

# Define the job to update game statuses
every 1.day, at: "18:00 JST" do
  runner "FetchGameDataJob.perform_now" # Ensure this calls the correct job
  runner "UpdateGameStatusJob.perform_now"
end
