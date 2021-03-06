module LinkPreviewStubs
  DEFAULT_PROPERTIES = Hash[LinkPreview::Content::PROPERTIES.map { |property| [property, nil] }]

  def stub_content_not_found(uri = an_instance_of(String))
    content = double('content', DEFAULT_PROPERTIES.merge(found?: false, source: {}))
    stub_content_helper uri, content
  end

  def stub_content(uri = an_instance_of(String), properties = {})
    nested_properties = Hash.new { |h, k| h[k] = {} }
    nested_properties.merge!(properties.select { |_k, v| v.is_a?(Hash) })
    simple_properties = properties.reject { |_k, v| v.is_a?(Hash) }

    content = double('content', DEFAULT_PROPERTIES.merge(found?: true).merge(simple_properties))
    allow(content).to receive(:sources).and_return(nested_properties)
    allow(content).to receive(:as_oembed).and_return({ version: '1.0', type: 'link' }.merge(nested_properties[:oembed]))

    stub_content_helper uri, content
  end

  private

  def stub_content_helper(uri, content)
    allow(LinkPreview).to receive(:fetch).with(uri, an_instance_of(Hash), an_instance_of(Hash)).and_return(content)
  end
end
