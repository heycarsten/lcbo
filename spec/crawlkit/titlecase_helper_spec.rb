# coding: utf-8
require 'spec_helper'

describe LCBO::CrawlKit::TitleCaseHelper do
  @expectations = {
    'PURPLE DRANK'                     => 'Purple Drank',
    'BEST-WINE EVAR!'                  => 'Best-Wine Evar!',
    'MONDAVI TO-KALON FUMÉ BLANC'      => 'Mondavi To-Kalon Fumé Blanc',
    'ÉVE PICARD'                       => 'Éve Picard',
    'R. PHILLIPS NIGHT HARVEST SHIRAZ' => 'R. Phillips Night Harvest Shiraz',
    '02 OPUS ONE NAPA VALLEY C.V.B.G'  => '02 Opus One Napa Valley C.V.B.G',
    'LONDON XXX'                       => 'London XXX',
    'SOME NICE VQA WINE'               => 'Some Nice VQA Wine',
    'A PRODUCT NAME (WITH STUPID CRAP' => 'A Product Name',
    'A PRODUCT NAME (FROM FRANCE)'     => 'A Product Name' }

  @expectations.each_pair do |input, expectation|
    it "should convert: #{input.inspect} to: #{expectation.inspect}" do
      LCBO::CrawlKit::TitleCaseHelper[input].should == expectation
    end
  end

  it 'should translate lowercase characters to uppercase characters properly' do
    upper = LCBO::CrawlKit::TitleCaseHelper::UPPER_CHARS
    lower = LCBO::CrawlKit::TitleCaseHelper::LOWER_CHARS
    LCBO::CrawlKit::TitleCaseHelper.upcase(lower).should == upper
  end

end
