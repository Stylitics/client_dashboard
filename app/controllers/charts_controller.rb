class ChartsController < ApplicationController
  def show
    @chart = Chart.find(params[:id])
    #render json: @chart.r_script.last_run.output
    render json: '[
  {
    "date": "2012-06-04",
    "adjustedSpecificItemsAdded": "0.0275813295615276",
    "adjustedSpecificWearings": "0.0319829424307036"
  },
  {
    "date": "2012-06-11",
    "adjustedSpecificItemsAdded": "0.0127175368139224",
    "adjustedSpecificWearings": "0.0234042553191489"
  },
  {
    "date": "2012-06-18",
    "adjustedSpecificItemsAdded": "0.0091324200913242",
    "adjustedSpecificWearings": "0.0362595419847328"
  },
  {
    "date": "2012-06-25",
    "adjustedSpecificItemsAdded": "0.0145161290322581",
    "adjustedSpecificWearings": "0.0209205020920502"
  },
  {
    "date": "2012-07-02",
    "adjustedSpecificItemsAdded": "0.0179372197309417",
    "adjustedSpecificWearings": "0.032051282051282"
  },
  {
    "date": "2012-07-09",
    "adjustedSpecificItemsAdded": "0.0154494382022472",
    "adjustedSpecificWearings": "0.019271948608137"
  },
  {
    "date": "2012-07-16",
    "adjustedSpecificItemsAdded": "0.00837988826815642",
    "adjustedSpecificWearings": "0.025369978858351"
  },
  {
    "date": "2012-07-23",
    "adjustedSpecificItemsAdded": "0.00522875816993464",
    "adjustedSpecificWearings": "0.0199115044247788"
  },
  {
    "date": "2012-07-30",
    "adjustedSpecificItemsAdded": "0.00659824046920821",
    "adjustedSpecificWearings": "0.0274725274725275"
  },
  {
    "date": "2012-08-06",
    "adjustedSpecificItemsAdded": "0.00588235294117647",
    "adjustedSpecificWearings": "0.0163339382940109"
  },
  {
    "date": "2012-08-13",
    "adjustedSpecificItemsAdded": "0.0121212121212121",
    "adjustedSpecificWearings": "0.0404191616766467"
  },
  {
    "date": "2012-08-20",
    "adjustedSpecificItemsAdded": "0.00611845325501713",
    "adjustedSpecificWearings": "0.0272479564032698"
  },
  {
    "date": "2012-08-27",
    "adjustedSpecificItemsAdded": "0.00705019740552735",
    "adjustedSpecificWearings": "0.0213049267643142"
  },
  {
    "date": "2012-09-03",
    "adjustedSpecificItemsAdded": "0.00897435897435897",
    "adjustedSpecificWearings": "0.0353658536585366"
  },
  {
    "date": "2012-09-10",
    "adjustedSpecificItemsAdded": "0.0176106615897192",
    "adjustedSpecificWearings": "0.031813361611877"
  },
  {
    "date": "2012-09-17",
    "adjustedSpecificItemsAdded": "0.0132645541635962",
    "adjustedSpecificWearings": "0.0326223337515684"
  },
  {
    "date": "2012-09-24",
    "adjustedSpecificItemsAdded": "0.00731452455590387",
    "adjustedSpecificWearings": "0.0314861460957179"
  },
  {
    "date": "2012-10-01",
    "adjustedSpecificItemsAdded": "0.00807955251709136",
    "adjustedSpecificWearings": "0.0333716915995397"
  },
  {
    "date": "2012-10-08",
    "adjustedSpecificItemsAdded": "0.00372920252438325",
    "adjustedSpecificWearings": "0.0271444082519001"
  },
  {
    "date": "2012-10-15",
    "adjustedSpecificItemsAdded": "0.0266824785057812",
    "adjustedSpecificWearings": "0.0243288590604027"
  },
  {
    "date": "2012-10-22",
    "adjustedSpecificItemsAdded": "0.0211800302571861",
    "adjustedSpecificWearings": "0.0245202558635394"
  },
  {
    "date": "2012-10-29",
    "adjustedSpecificItemsAdded": "0.0106382978723404",
    "adjustedSpecificWearings": "0.0397260273972603"
  },
  {
    "date": "2012-11-05",
    "adjustedSpecificItemsAdded": "0.00598802395209581",
    "adjustedSpecificWearings": "0.0179372197309417"
  },
  {
    "date": "2012-11-12",
    "adjustedSpecificItemsAdded": "0.028169014084507",
    "adjustedSpecificWearings": "0.036096256684492"
  },
  {
    "date": "2012-11-19",
    "adjustedSpecificItemsAdded": "0.00737735153080044",
    "adjustedSpecificWearings": "0.0423620025673941"
  },
  {
    "date": "2012-11-26",
    "adjustedSpecificItemsAdded": "0.00942782834850455",
    "adjustedSpecificWearings": "0.0374732334047109"
  },
  {
    "date": "2012-12-03",
    "adjustedSpecificItemsAdded": "0.00503018108651911",
    "adjustedSpecificWearings": "0.0367197062423501"
  },
  {
    "date": "2012-12-10",
    "adjustedSpecificItemsAdded": "0.00808709175738725",
    "adjustedSpecificWearings": "0.0324873096446701"
  },
  {
    "date": "2012-12-17",
    "adjustedSpecificItemsAdded": "0.00813692480359147",
    "adjustedSpecificWearings": "0.0303030303030303"
  },
  {
    "date": "2012-12-24",
    "adjustedSpecificItemsAdded": "0.00165929203539823",
    "adjustedSpecificWearings": "0.027027027027027"
  },
  {
    "date": "2012-12-31",
    "adjustedSpecificItemsAdded": "0.00452879016605564",
    "adjustedSpecificWearings": "0.0404624277456647"
  },
  {
    "date": "2013-01-07",
    "adjustedSpecificItemsAdded": "0.00501762950908598",
    "adjustedSpecificWearings": "0.0275545350172216"
  },
  {
    "date": "2013-01-14",
    "adjustedSpecificItemsAdded": "0.0102611940298507",
    "adjustedSpecificWearings": "0.0500472143531634"
  },
  {
    "date": "2013-01-21",
    "adjustedSpecificItemsAdded": "0.00573065902578797",
    "adjustedSpecificWearings": "0.0258899676375405"
  },
  {
    "date": "2013-01-28",
    "adjustedSpecificItemsAdded": "0.00688349681638272",
    "adjustedSpecificWearings": "0.0363984674329502"
  },
  {
    "date": "2013-02-04",
    "adjustedSpecificItemsAdded": "0.0103035878564857",
    "adjustedSpecificWearings": "0.0288888888888889"
  },
  {
    "date": "2013-02-11",
    "adjustedSpecificItemsAdded": "0.00813439434129089",
    "adjustedSpecificWearings": "0.0219895287958115"
  },
  {
    "date": "2013-02-18",
    "adjustedSpecificItemsAdded": "0.0157157499145883",
    "adjustedSpecificWearings": "0.0307017543859649"
  },
  {
    "date": "2013-02-25",
    "adjustedSpecificItemsAdded": "0.0142290646139491",
    "adjustedSpecificWearings": "0.0305907172995781"
  },
  {
    "date": "2013-03-04",
    "adjustedSpecificItemsAdded": "0.0125886524822695",
    "adjustedSpecificWearings": "0.044"
  },
  {
    "date": "2013-03-11",
    "adjustedSpecificItemsAdded": "0.00908540278619019",
    "adjustedSpecificWearings": "0.0502958579881657"
  },
  {
    "date": "2013-03-18",
    "adjustedSpecificItemsAdded": "0.0157868771583621",
    "adjustedSpecificWearings": "0.0609504132231405"
  },
  {
    "date": "2013-03-25",
    "adjustedSpecificItemsAdded": "0.0125019057783199",
    "adjustedSpecificWearings": "0.0531400966183575"
  },
  {
    "date": "2013-04-01",
    "adjustedSpecificItemsAdded": "0.0089223233030091",
    "adjustedSpecificWearings": "0.055359246171967"
  },
  {
    "date": "2013-04-08",
    "adjustedSpecificItemsAdded": "0.010989010989011",
    "adjustedSpecificWearings": "0.0236220472440945"
  }
]
'
  end
end
