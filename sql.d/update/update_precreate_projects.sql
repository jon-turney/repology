-- Copyright (C) 2020 Dmitry Marakasov <amdmi3@amdmi3.ru>
--
-- This file is part of repology
--
-- repology is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- repology is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with repology.  If not, see <http://www.gnu.org/licenses/>.

-- XXX: this is temporary solution to have all referenced projects
-- available for update queries which are run later. All projects
-- update code should be moved here in future

WITH old AS (
	SELECT
		effname
	FROM packages
	WHERE effname IN (SELECT effname FROM changed_projects)
	GROUP BY effname
), new AS (
	SELECT
		effname
	FROM incoming_packages
	GROUP BY effname
)
INSERT INTO metapackages (
	effname
)
SELECT
	effname
FROM old
RIGHT OUTER JOIN new USING(effname)
WHERE old.effname IS NULL
ON CONFLICT(effname) DO NOTHING;
