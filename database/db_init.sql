CREATE OR REPLACE FUNCTION trigger_set_updated() RETURNS TRIGGER AS $$
BEGIN
	NEW.updated = NOW();
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/*
SETUP PROPOSALS TABLE
*/
CREATE TABLE if NOT EXISTS proposals (
	title varchar(100) NOT NULL,
    author_name TEXT NOT NULL,
    voter_email TEXT NOT NULL,
	summary TEXT NOT NULL,
	description TEXT,
	type varchar(32) NOT NULL,
	status varchar(32) DEFAULT 'open' NOT NULL,
	id SERIAL PRIMARY KEY,
	created TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE OR REPLACE TRIGGER set_updated
BEFORE UPDATE ON proposals
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_updated();

/*
SETUP VOTING TABLE
*/

CREATE TABLE if NOT EXISTS votes (
	voter_email TEXT NOT NULL,
	proposal_id INT NOT NULL REFERENCES proposals(id),
	vote INT,
    comment TEXT,
	created TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
	id SERIAL PRIMARY KEY,
    CONSTRAINT unique_vote UNIQUE (voter_email, proposal_id)
);

CREATE OR REPLACE TRIGGER set_updated
BEFORE UPDATE ON votes
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_updated();

/*
SETUP DRAFTS TABLE
*/
CREATE TABLE if NOT EXISTS drafts (
     title varchar(48),
     summary TEXT,
     description TEXT,
     type varchar(32),
     id SERIAL PRIMARY KEY,
     created TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
     updated TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
     voter_email TEXT NOT NULL
);

CREATE OR REPLACE TRIGGER set_updated
BEFORE UPDATE ON drafts
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_updated();
