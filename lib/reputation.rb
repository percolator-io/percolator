class Reputation
  attr_reader :host, :wot

  def initialize(host)
    @host = host
    key = Figaro.env.wot_key
    @wot = Wot.new(key)
  end

  def get
    rep = wot.reputation(host)[host]

    trustworthiness = {}
    child_safety = {}

    raw_trustworthiness = rep['0']
    if raw_trustworthiness.present?
      trustworthiness[:reputation] = raw_trustworthiness.first
      trustworthiness[:confidence] = raw_trustworthiness.second
    end

    raw_child_safety = rep['4']
    if raw_child_safety.present?
      child_safety[:reputation] = raw_child_safety.first
      child_safety[:confidence] = raw_child_safety.second
    end

    {
        trustworthiness: trustworthiness,
        child_safety: child_safety,
        blacklists: rep['blacklists'].present?
    }
  end
end
