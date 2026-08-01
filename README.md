# Polybank

![](https://cdn.hackclub.com/019fbac1-2a74-7c63-84b2-3008f1c330bc/pawelzmarlak-2026-08-01T00_37_16.399Z.png)

Polybank is a website for managing your finances!
It serves as a simple and easy-to-use interface for all of your
financial accounts, such as your checking/savings accounts, credit cards,
and investment accounts.

It currently supports:
- Basic user creation and authentication
- Connecting to financial institutions via [Plaid Link](https://plaid.com/docs/link/)
- Viewing account balances
- Viewing, searching, and filtering transactions
- Exporting transactions to CSV or PDF
- Categorizing and tagging transactions
- Viewing transaction counterparties
- Viewing income and spending graphs, including a Sankey diagram 

## Technical

Polybank is built using Ruby on Rails, TailwindCSS, and several other helpful gems.

Polybank uses [Plaid](https://plaid.com/) to connect to financial institutions
and import data in real time. However, it is designed to not require Plaid in order
to use Polybank.

## Getting started

Polybank currently uses a SQLite database, so nothing other than the Ruby on Rails server
itself is required to run it.

1. [Install Ruby](https://www.ruby-lang.org/en/documentation/installation/)
2. Clone the repo (`git clone https://github.com/polypixeldev/polybank.git`)
3. Run `bundle install`
4. Copy `example.env` to `.env` and fill in the environment variables
5. Start the server with `bin/dev`

## Development

I started working on Polybank because many US financial institutions don't have a good
UI for you to manage your finances. With Polybank, I can easily extend the interface
and adapt it to my needs.

Claude Web was used to help debug specific problems that I ran into while
making Polybank. I made sure to check and understand the small snippets of code
that I did not write myself.
