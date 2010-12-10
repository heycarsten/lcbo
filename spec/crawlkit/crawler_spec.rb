require 'spec_helper'

module CrawlerSpec
  module TheInternets

    RESOURCES = {
      'list?page=1' => {
        :ids => [1, 2],
        :page => 1,
        :next_page => 2
      },
      'list?page=2' => {
        :ids => [3, 4],
        :page => 2,
        :next_page => 3
      },
      'list?page=3' => {
        :ids => [5, 6],
        :page => 3,
        :next_page => nil
      },
      'books/1' => {
        :id => 1,
        :title => 'book_1'
      },
      'books/2' => {
        :id => 2,
        :title => 'book_2'
      },
      'books/3' => {
        :id => 3,
        :title => 'book_3'
      },
      'books/4' => {
        :id => 4,
        :title => 'book_4'
      },
      'books/5' => {
        :id => 5,
        :title => 'book_5'
      },
      'books/6' => {
        :id => 6,
        :title => 'book_6'
      }
    }

    def self.get(uri)
      RESOURCES.fetch(uri) do
        raise LCBO::CrawlKit::NotFoundError, "#{uri} does not exist"
      end
    end

  end


  class BookCrawler

    include LCBO::CrawlKit::Crawler

    def request(book_id)
      TheInternets.get("books/#{book_id}")
    end

  end


  class BookListsCrawler

    include LCBO::CrawlKit::Crawler

    def request(params)
      TheInternets.get("list?page=#{params[:next_page] || 1}")
    end

    def continue?(page)
      page[:next_page] ? true : false
    end

    def reduce
      responses.map { |page| page[:ids] }.flatten
    end

  end


  class EnumBooksCrawler

    include LCBO::CrawlKit::Crawler

    def enum
      BookListsCrawler.run
    end

    def request(book_id)
      TheInternets.get("books/#{book_id}")
    end

  end


  class QueueBooksCrawler

    QUEUE = [1, 2, 3, 4, 0, 5, 6]
    MISSING = []

    include LCBO::CrawlKit::Crawler

    def pop
      QUEUE.pop
    end

    def request(book_id)
      TheInternets.get("books/#{book_id}")
    end

    def failure(error, book_id)
      case error
      when LCBO::CrawlKit::NotFoundError
        MISSING.push(book_id)
      else
        raise error
      end
    end

  end
end

describe CrawlerSpec::TheInternets do
  it 'should let you get a resource' do
    CrawlerSpec::TheInternets.get('books/1')[:title].must_equal 'book_1'
  end

  it 'should throw an error when a resource does not exist' do
    -> { CrawlerSpec::TheInternets.get('books/0') }.must_raise LCBO::CrawlKit::NotFoundError
  end
end

describe CrawlerSpec::BookCrawler do
  it 'should return a book' do
    CrawlerSpec::BookCrawler.run(1)[:title].must_equal 'book_1'
  end

  it 'should yield a book' do
    title = nil
    CrawlerSpec::BookCrawler.run(1) { |page| title = page[:title] }
    title.must_equal 'book_1'
  end

  it 'should raise an error if a book does not exist' do
    -> { CrawlerSpec::BookCrawler.run(0) }.must_raise LCBO::CrawlKit::NotFoundError
  end
end

describe CrawlerSpec::BookListsCrawler do
  it 'should return all the book ids' do
    CrawlerSpec::BookListsCrawler.run.must_equal [1, 2, 3, 4, 5, 6]
  end

  it 'should emit all the pages' do
    pages = []
    CrawlerSpec::BookListsCrawler.run { |page| pages << page }
    pages.size.must_equal 3
  end

  it 'should consider provided params' do
    pages = []
    CrawlerSpec::BookListsCrawler.run(:next_page => 2) { |page| pages << page }
    pages.size.must_equal 2
  end
end

describe CrawlerSpec::EnumBooksCrawler do
  it 'should emit all the books' do
    books = []
    CrawlerSpec::EnumBooksCrawler.run { |book| books << book }
    books.size.must_equal 6
  end

  it 'should emit books when provided with their params' do
    books = []
    CrawlerSpec::EnumBooksCrawler.run([1, 2, 3]) { |book| books << book }
    books.size.must_equal 3
  end
end

describe CrawlerSpec::QueueBooksCrawler do
  it 'should emit all the books that did not fail' do
    CrawlerSpec::QueueBooksCrawler::QUEUE.size.must_equal 7
    books = []
    CrawlerSpec::QueueBooksCrawler.run { |book| books << book }
    books.size.must_equal 6
    CrawlerSpec::QueueBooksCrawler::QUEUE.size.must_equal 0
    CrawlerSpec::QueueBooksCrawler::MISSING.size.must_equal 1
  end
end
