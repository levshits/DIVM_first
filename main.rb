require 'matrix'
require 'mathn'
def enter_button_click
  #do nothing
  p 'enter button'
end
def grid_click
  #do nothing
  p 'grid'
end
class Vector
  def /(arg)
    self * (1 / arg)
  end
end
class Slae

  def initialize(n)
    @slae = n
  end
  def get_slae(i,j)
    @slae[i][j]
  end
  def get_full_table
    @slae
  end
  def get_size
    @slae.size
  end
  def solve_by_gauss?
    (0...@slae.size).each{ |i|
      max_index = i
      max_element = @slae[i][i]
      (i...@slae.size).each{|j| if @slae[j][i]>max_element
                                  max_element=@slae[j][i]
                                  max_index = j
                                end}
      if max_index!=i
        temp = @slae[i]
        @slae[i] = @slae[max_index]
        @slae[max_index] = temp
      end
    }
    (0...@slae.size).each{ |i| if @slae[i][i]!=0
                                 @slae[i] /= @slae[i][i]
                                 p @slae
                                 (i+1...@slae.size).each{ |j| @slae[j] -= @slae[i] * @slae[j][i] }
                                 p @slae
                               end
    }
    p @slae
    (1...@slae.size).to_a.reverse.each{ |i|
      (0...i).each{ |j| @slae[j] -= @slae[i] * @slae[j][i] }
      if @slae[i][i]==0
        if @slae[i][i] == @slae[i][i+1]
          p "Unlimited count of solutions"
          return false
        else
          p "No solution"
          return false
        end
      end}
    true
  end
  def solve_by_holetsky?
    l_matrix = Array.new(@slae.size){Array.new(@slae.size+1,0)}

    (0...@slae.size).each{|i|
      (0...i).each{ |j|
        temp=0
        (0...j).each{ |k|
          temp+=l_matrix[i][k]*l_matrix[j][k]
        }
        l_matrix[i][j] = (@slae[i][j] - temp)/l_matrix[j][j]
      }

      temp = @slae[i][i]
      (0...i).each{ |k| temp-=l_matrix[i][k]*l_matrix[i][k]}
      l_matrix[i][i] = Math.sqrt(temp)
    }
    p l_matrix
    lt_matrix = Array.new(@slae.size){Array.new(@slae.size+1,0)}
    (0...@slae.size).each{ |i| (0...@slae.size).each{|j|
      lt_matrix[i][j] = l_matrix[j][i]
      if l_matrix[j][i].is_a?(Complex)
        p "System can't be solved by this method"
        return false
      end}}
    (0...@slae.size).each{|i| l_matrix[i][-1]=@slae[i][-1]}
    l_matrix  = l_matrix.map{ |array| Vector[*array]}
    buffer_slae = Slae.new(l_matrix)
    buffer_slae.solve_by_gauss?
    (0...@slae.size).each{|i| lt_matrix[i][-1] = buffer_slae.get_slae(i, -1)}
    lt_matrix  = lt_matrix.map{ |array| Vector[*array]}
    buffer_slae = Slae.new(lt_matrix)
    buffer_slae.solve_by_gauss?
    @slae = buffer_slae.get_full_table
    true
  end
end
class Main
  def initialize
    #first = Slae.new([Vector[81,-45,45,531], Vector[-45,50,-15,-460], Vector[45,-15,38,193]])
    #first = Slae.new([Vector[1,1,1,6], Vector[1,0,1,-2], Vector[1,2,1,14]])
    #first = Slae.new([Vector[3.43,3.38,3.09,5.52], Vector[4.17,4.00,3.65,5.93], Vector[4.30,4.10,3.67,7.29]])
    p "Please enter dimension of matrix"
    dimension = gets.chomp.to_i
    matrix_array = Array.new(dimension){Array.new(dimension+1,0)}
    (0...dimension).each{|i| (0...dimension+1).each{|j|
      p "Please, enter ["+ i.to_s + "]["+j.to_s+"] element"
      matrix_array[i][j] = gets.chomp.to_f}}
    p  matrix_array
    slae = Slae.new(matrix_array.map{|array| Vector[*array]})
    p "Choose variant of solving"
    p "1. Holetsky"
    p "2. Gauss"
    case gets.chomp.to_i
      when(1)
        slae.solve_by_holetsky? ?
            (0...slae.get_size).each { |i| p slae.get_slae(i, -1) } : p {"try yet another"}
      when(2)
        slae.solve_by_gauss? ?
            (0...slae.get_size).each { |i| p slae.get_slae(i, -1) } : p {"try yet another"}
    end
  end
end
Main.new
gets.chomp