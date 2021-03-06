/*
* Copyright (c) 2017 David Hewitt <davidmhewitt@gmail.com>
*               2017 elementary LLC.
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: David Hewitt <davidmhewitt@gmail.com>
*/

namespace Synapse {
    public class WebSearchPlugin: Object, Activatable, ItemProvider {

        public bool enabled { get; set; default = true; }

        public void activate () { }

        public void deactivate () { }

        public class Result : Object, Match {
            // from Match interface
            public string title { get; construct set; }
            public string description { get; set; }
            public string icon_name { get; construct set; }
            public bool has_thumbnail { get; construct set; }
            public string thumbnail_path { get; construct set; }
            public MatchType match_type { get; construct set; }
			public string query_template { get; construct set; }

            public int default_relevancy { get; set; default = 0; }

            private AppInfo? appinfo;
            private string search_term;

            public Result (string search) {
                search_term = search;

                string _title = search_term;
                string _icon_name = "applications-internet";

                this.title = _title;
                this.icon_name = _icon_name;
                this.description = _("Search for: " + search);
                this.has_thumbnail = true;
                this.match_type = MatchType.SEARCH;
            }

            public void execute (Match? match) {
                AppInfo.launch_default_for_uri (_("https://www.ecosia.org/search?q="+title), null);
            }        
        }

        static void register_plugin () {
            DataSink.PluginRegistry.get_default ().register_plugin (typeof (WebSearchPlugin),
                                            _("WebSearch"),
                                            _("Search the web for result"),
                                            "applications-internet",
                                            register_plugin);
        }

        static construct {
            register_plugin ();
        }

        public async ResultSet? search (Query query) throws SearchError {
			if(query.query_type == QueryFlags.ACTIONS)
				return null;
				
			ResultSet results = new ResultSet ();
			Result search_result = new Result (query.query_string);
			results.add (search_result, Match.Score.INCREMENT_MINOR);

			return results;
        }
    }
}
