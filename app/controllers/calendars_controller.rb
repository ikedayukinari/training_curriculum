class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ (rootで設定してある)
  def index
    getWeek #(ここはまじで難関)

    @plan = Plan.new #(index.htmlのform_withへ)
  end

  # 予定の保存 (モデル.createでDBへの作成と保存を一緒にしてくれてる)
  def create
    Plan.create(plan_params) #(ここはストロングパラメーター)

    redirect_to action: :index #(無事に終わるとindexアクションへ)
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan) #(form_withからの情報を受け取っている)
  end

  def getWeek
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)'] #(wdaysは一週間のこと)

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。

    @todays_date = Date.today #(@todays_dateは今日の日付を取得している)
                              # 例) 今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = [] #(@week_daysという配列に .push を使う事で(days)要素を追加している)

    plans = Plan.where(date: @todays_date..@todays_date + 6) #(モデル.whereってなんだ！？ → 引数に入っている条件と合っている全てのレコードを取得)
    #(plansの中身が分からん  @todays_date + 6って何？)

    7.times do |x|
      today_plans = []
      plan = plans.map do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end

      
      days = { month: (@todays_date + x).month, date: (@todays_date+x).day, plans: today_plans, wday: wdays[(@todays_date + x).wday]}
      @week_days.push(days)
    end

  end
end
#   