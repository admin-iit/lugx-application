import React, { useState, useEffect } from 'react';
import { useGaming } from '../contexts/GamingContext';
import './Analytics.css';

const Analytics = () => {
  const { products, loading: productsLoading } = useGaming();
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const response = await fetch('/api/users');
        const data = await response.json();
        if (data.success) {
          setUsers(data.data);
        } else {
          setError('Failed to fetch users');
        }
      } catch (err) {
        setError('Error fetching users: ' + err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchUsers();
  }, []);

  const getTotalValue = () => {
    return products.reduce((total, product) => {
      return total + (parseFloat(product.price) * product.stock);
    }, 0).toFixed(2);
  };

  const getCategoryStats = () => {
    const stats = {};
    products.forEach(product => {
      stats[product.category] = (stats[product.category] || 0) + 1;
    });
    return stats;
  };

  const getPlatformStats = () => {
    const stats = {};
    products.forEach(product => {
      stats[product.platform] = (stats[product.platform] || 0) + 1;
    });
    return stats;
  };

  const getTopRatedProducts = () => {
    return products
      .filter(product => product.rating)
      .sort((a, b) => parseFloat(b.rating) - parseFloat(a.rating))
      .slice(0, 5);
  };

  const getRecentUsers = () => {
    return users
      .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt))
      .slice(0, 5);
  };

  if (loading || productsLoading) {
    return (
      <div className="analytics-container">
        <div className="loading">
          <div className="loading-spinner"></div>
          Loading Analytics Dashboard...
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="analytics-container">
        <div className="error">Error: {error}</div>
      </div>
    );
  }

  const categoryStats = getCategoryStats();
  const platformStats = getPlatformStats();
  const topRatedProducts = getTopRatedProducts();
  const recentUsers = getRecentUsers();

  return (
    <div className="analytics-container">
      <div className="analytics-header">
        <h1>📊 RDS Data Analytics Dashboard</h1>
        <p>Real-time data from PostgreSQL RDS Database</p>
      </div>

      {/* Overview Cards */}
      <div className="stats-grid">
        <div className="stat-card">
          <h3>Total Products</h3>
          <div className="stat-number">{products.length}</div>
          <div className="stat-label">Games in Database</div>
        </div>
        
        <div className="stat-card">
          <h3>Total Users</h3>
          <div className="stat-number">{users.length}</div>
          <div className="stat-label">Registered Users</div>
        </div>
        
        <div className="stat-card">
          <h3>Inventory Value</h3>
          <div className="stat-number">${getTotalValue()}</div>
          <div className="stat-label">Total Stock Value</div>
        </div>
        
        <div className="stat-card">
          <h3>Avg Rating</h3>
          <div className="stat-number">
            {products.length > 0 
              ? (products.reduce((sum, p) => sum + parseFloat(p.rating || 0), 0) / products.length).toFixed(1)
              : '0.0'
            }
          </div>
          <div className="stat-label">Average Product Rating</div>
        </div>
      </div>

      {/* Category Distribution */}
      <div className="analytics-section">
        <h2>📈 Product Categories</h2>
        <div className="category-grid">
          {Object.entries(categoryStats).map(([category, count]) => (
            <div key={category} className="category-card">
              <h4>{category.toUpperCase()}</h4>
              <div className="category-count">{count}</div>
              <div className="category-percentage">
                {((count / products.length) * 100).toFixed(1)}%
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Platform Distribution */}
      <div className="analytics-section">
        <h2>🎮 Platform Distribution</h2>
        <div className="platform-grid">
          {Object.entries(platformStats).map(([platform, count]) => (
            <div key={platform} className="platform-card">
              <h4>{platform.toUpperCase()}</h4>
              <div className="platform-count">{count}</div>
              <div className="platform-percentage">
                {((count / products.length) * 100).toFixed(1)}%
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Top Rated Products */}
      <div className="analytics-section">
        <h2>⭐ Top Rated Products</h2>
        <div className="top-products-list">
          {topRatedProducts.map((product, index) => (
            <div key={product.id} className="product-rank-card">
              <div className="rank-number">#{index + 1}</div>
              <div className="product-info">
                <h4>{product.name}</h4>
                <p>{product.description}</p>
                <div className="product-meta">
                  <span className="rating">⭐ {product.rating}</span>
                  <span className="price">${product.price}</span>
                  <span className="category">{product.category}</span>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Recent Users */}
      <div className="analytics-section">
        <h2>👥 Recent Users</h2>
        <div className="users-list">
          {recentUsers.map((user, index) => (
            <div key={user.id} className="user-card">
              <div className="user-info">
                <h4>{user.username}</h4>
                <p>{user.email}</p>
                <div className="user-meta">
                  <span className="join-date">
                    Joined: {new Date(user.createdAt).toLocaleDateString()}
                  </span>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Database Connection Status */}
      <div className="analytics-section">
        <h2>🔗 Database Connection Status</h2>
        <div className="connection-status">
          <div className="status-indicator success">
            <span className="status-dot"></span>
            Connected to PostgreSQL RDS
          </div>
          <div className="db-info">
            <p><strong>Database:</strong> iit-rds-tests-01.cfwsc626ix76.ap-southeast-1.rds.amazonaws.com</p>
            <p><strong>Last Update:</strong> {new Date().toLocaleString()}</p>
            <p><strong>Records:</strong> {products.length} products, {users.length} users</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Analytics;
