package com.xf.dao;

import com.xf.entity.Review;
import com.xf.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReviewDao {
    public List<Review> getAll() {
        String sql = "select r.rid,r.sid,s.sname,r.account,r.score,r.content,r.created_at " +
                "from review r left join shopping s on r.sid=s.sid order by r.created_at desc";
        List<Review> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(readReview(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public int add(Review review) {
        String sql = "insert into review(rid,sid,account,score,content) values(?,?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, review.getRid());
            ps.setString(2, review.getSid());
            ps.setString(3, review.getAccount());
            ps.setInt(4, review.getScore());
            ps.setString(5, review.getContent());
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public int update(Review review) {
        String sql = "update review set score=?,content=? where rid=? and account=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, review.getScore());
            ps.setString(2, review.getContent());
            ps.setString(3, review.getRid());
            ps.setString(4, review.getAccount());
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public int delete(String rid, String account) {
        String sql = "delete from review where rid=? and account=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, rid);
            ps.setString(2, account);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private Review readReview(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setRid(rs.getString("rid"));
        review.setSid(rs.getString("sid"));
        review.setSname(rs.getString("sname"));
        review.setAccount(rs.getString("account"));
        review.setScore(rs.getInt("score"));
        review.setContent(rs.getString("content"));
        review.setCreatedAt(rs.getString("created_at"));
        return review;
    }
}
