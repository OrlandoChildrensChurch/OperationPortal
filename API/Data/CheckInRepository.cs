﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Threading.Tasks;
using Npgsql;
using API.Models;
using System.Data;
using System.Text;

namespace API.Data
{
    public class CheckInRepository
    {
        private readonly string connString;
        public CheckInRepository(string connString)
        {
            this.connString = connString;
        }

        /// <summary>
        /// Marks a child as present for the day
        /// </summary>
        /// <param name="childid">Child id being marked present</param>
        /// <returns>Total number of times the child has been in attendance</returns>
        public int CheckInChild(int childid)
        {
            int numVisits = 0;
            DateTime now = DateTime.UtcNow;
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                con.Open();
                DataTable dt = new DataTable();

                // Retrieve all the days the child has been in attendance, ordered by most recent first
                string sql = "SELECT * FROM Child_Attendance WHERE childid = @childid ORDER BY dayattended DESC";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@childid", NpgsqlTypes.NpgsqlDbType.Integer).Value = childid;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                }

                numVisits = dt.Rows.Count;

                // Record child's attendance, checking if the child has previously been marked for the day
                if (dt.Rows.Count == 0 || string.Compare(dt.Rows[0]["dayattended"].ToString(), now.Date.ToString()) != 0)
                {
                    sql = @"INSERT INTO Child_Attendance (childid, dayattended)
                            VALUES (@childid, @now)";
                    using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                    {
                        cmd.Parameters.Add("@childid", NpgsqlTypes.NpgsqlDbType.Integer).Value = childid;
                        cmd.Parameters.Add("@now", NpgsqlTypes.NpgsqlDbType.Date).Value = now;
                        cmd.ExecuteNonQuery();
                    }

                    // Add today's visit to the total
                    numVisits++;
                }

                con.Close();
            }

            return numVisits;
        }

        /// <summary>
        /// Marks a volunteer as present for the day, assigns roster/child notes permissions, and assigns bus/class as needed
        /// </summary>
        /// <returns>Total number of times the volunteer has been in attendance</returns>
        public int CheckInVolunteer(int volunteerId, int? classId, int? busId, bool viewNotes, bool viewRoster)
        {
            int numVisits = 0;
            DateTime now = DateTime.UtcNow;
            using (NpgsqlConnection con = new NpgsqlConnection(connString))
            {
                con.Open();
                DataTable dt = new DataTable();

                // Mark attended if scheduled for this date
                string sql = @"SELECT dayattended, attended FROM Volunteer_Attendance 
                               WHERE volunteerid = @volunteerId 
                               AND dayattended = @now";
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@volunteerId", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;
                    cmd.Parameters.Add("@now", NpgsqlTypes.NpgsqlDbType.Date).Value = now;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                }

                bool justCheckedIn = false;

                // Volunteer wasn't scheduled for this day, add to table as checked in and unscheduled
                if (dt.Rows.Count == 0)
                {
                    sql = @"INSERT INTO Volunteer_Attendance (volunteerid, dayattended, scheduled, attended, busid, viewnotes, viewroster)
                            VALUES (@volunteerId, @now, CAST(0 as bit), CAST(1 as bit), (CASE WHEN @busId = -1 THEN NULL ELSE @busId END), @viewNotes, @viewRoster)";
                    using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                    {
                        cmd.Parameters.Add("@volunteerId", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;
                        cmd.Parameters.Add("@now", NpgsqlTypes.NpgsqlDbType.Date).Value = now;
                        cmd.Parameters.Add("@busId", NpgsqlTypes.NpgsqlDbType.Integer).Value = busId == null ? -1 : busId;
                        cmd.Parameters.Add("@viewNotes", NpgsqlTypes.NpgsqlDbType.Bit).Value = viewNotes;
                        cmd.Parameters.Add("@viewRoster", NpgsqlTypes.NpgsqlDbType.Bit).Value = viewRoster;
                        cmd.ExecuteNonQuery();
                    }

                    justCheckedIn = true;
                }

                // Volunteer was scheduled and is checking in now
                else if (dt.Rows[0]["attended"] == null || !(bool)dt.Rows[0]["attended"])
                {
                    sql = @"UPDATE Volunteer_Attendance 
                            SET attended = CAST(1 as bit), busid = (CASE WHEN @busId = -1 THEN NULL ELSE @busId END), viewnotes = @viewNotes, viewroster = @viewRoster
                            WHERE volunteerid = @volunteerId
                            AND dayattended = @now";
                    using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                    {
                        cmd.Parameters.Add("@volunteerId", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;
                        cmd.Parameters.Add("@now", NpgsqlTypes.NpgsqlDbType.Date).Value = now;
                        cmd.Parameters.Add("@busId", NpgsqlTypes.NpgsqlDbType.Integer).Value = busId == null ? -1 : busId;
                        cmd.Parameters.Add("@viewNotes", NpgsqlTypes.NpgsqlDbType.Bit).Value = viewNotes;
                        cmd.Parameters.Add("@viewRoster", NpgsqlTypes.NpgsqlDbType.Bit).Value = viewRoster;
                        cmd.ExecuteNonQuery();
                    }

                    justCheckedIn = true;
                }

                if (justCheckedIn)
                {
                    // Add teacher assignment if present
                    if (classId != null)
                    {
                        sql = @"INSERT INTO Teacher_Assignments (teacherid, classid, classdate)
                                VALUES (@volunteerId, @classId, @now)";

                        using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                        {
                            cmd.Parameters.Add("@volunteerId", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;
                            cmd.Parameters.Add("@classId", NpgsqlTypes.NpgsqlDbType.Integer).Value = classId;
                            cmd.Parameters.Add("@now", NpgsqlTypes.NpgsqlDbType.Date).Value = now;
                            cmd.ExecuteNonQuery();
                        }
                    }

                    // Increment # weekends attended on Volunteers table
                    sql = @"UPDATE Volunteers
                            SET weekendsattended = weekendsattended + 1
                            WHERE id = @volunteerId";

                    using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                    {
                        cmd.Parameters.Add("@volunteerId", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;
                        cmd.ExecuteNonQuery();
                    }
                }

                // Find total number of visits
                sql = @"SELECT weekendsattended FROM Volunteers
                        WHERE id = @volunteerId";
                dt = new DataTable();
                using (NpgsqlCommand cmd = new NpgsqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@volunteerId", NpgsqlTypes.NpgsqlDbType.Integer).Value = volunteerId;
                    NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                    da.Fill(dt);
                }

                numVisits = (int)dt.Rows[0]["weekendsattended"];

                con.Close();
            }

            return numVisits;
        }
    }
}