atom_feed :language => 'en-US' do |feed|
  feed.title @title
  feed.updated @updated
  feed.author @user.name

  @microposts.each do |item|
    next if item.updated_at.blank?

    feed.entry( item ) do |entry|
      entry.content item.content, :type => 'html'
      # the strftime is needed to work with Google Reader.
      entry.updated(item.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) 
    end
  end
end